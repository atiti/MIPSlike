/**************************************************************************
* Assembler V.1.1 							  *
*									  *
* Group 4: 								  *
* Andreas B. Svendsen, Attila Sükösd and Kasper Grue Understrup		  *
* 									  *
**************************************************************************/

#include <stdio.h>
#include <string.h>

#define DEBUG 0
#define DEBUG_LABELS 1
#define DEBUG_INST 1
#define MAX_LABELS 1000

typedef struct {
	char label[50];
	int PC;
} Label_t;

static Label_t LABEL_TABLE[MAX_LABELS];
int labelcnt = 0;
int PC = 0;

void dec2bin(long decimal, char *binary, int length);
void RegisterRename(char A[], int absolute);
void lowerCase(char string[]);
void Offset(char C[],char B1[],char B2[]);
void pass1(char C[]);
void pass2(char C[]);
void clearFile();
int skip_spaces(char string[], int i);

void print_label_table() {
  int i=0;
  for(i=0;i<labelcnt;i++) {
	if(DEBUG_LABELS) printf("PASS1: #%d label: %s PC: %d\n", i, LABEL_TABLE[i].label, LABEL_TABLE[i].PC);
  }
}

/*Main function that read the input file and pass it on to convert*/
int main(int argc, char *argv[])
{

  char assemblerCode[100];
  FILE  *fp = fopen(argv[1], "rt");
  int linje=1, i=0, res=0;
  for(i=0;i<MAX_LABELS;i++) {
	LABEL_TABLE[i].label[0] = '\0';
	LABEL_TABLE[i].PC = 0;
  } 

  clearFile();
  if (fp == NULL) { perror ("Error opening file"); return 0; }
  /* PASS 1 */
  while(fgets (assemblerCode , 100 , fp)!=NULL) {  
	if (strlen(assemblerCode) > 2 && assemblerCode[0] != '#') { // Skip empty lines and comments    
 		pass1(assemblerCode);
    	}
  }

  print_label_table();       
  fseek(fp, 0, SEEK_SET); // Jump back to the beginning of the file
  PC = 0; // Reset program counter between passes

  /* PASS 2 */
  while(fgets(assemblerCode,100,fp) != NULL) {
	if (strlen(assemblerCode) > 2 && assemblerCode[0] != '#') {	
		pass2(assemblerCode);
	}
  }
  fclose (fp);
  return 0;
}

char is_branch(char pString[]) {
	char i;
	char *branchnames[] = {"b", "beq", "bne", "j", "jal", "jr"};
	for(i=0;i<6;i++) {
		if (!strncmp(pString, branchnames[i], strlen(branchnames[i])))
			return 1;
	}
	return 0;
}

/*

PASS 1: First pass through the assembler code

This pass fills up the label table

*/ 
void pass1(char pString[]) {
	int i = 0;
	char A[1000];
	i = skip_spaces(pString, i);
	if (pString[i] == '.') return;
	i = extract(A, pString, i);
	lowerCase(A);
	if (DEBUG_INST) printf("PC: %d (%d) INST: %s", PC*4, PC, pString);
	if (is_branch(A)) {
		if (DEBUG_INST) {
			printf("PC: %d (%d) INST: \tnop\n", (PC+1)*4, PC+1);
			printf("PC: %d (%d) INST: \tnop\n", (PC+2)*4, PC+2);
			printf("PC: %d (%d) INST: \tnop\n", (PC+3)*4, PC+3);
		}	
		PC += 3;
	}
	if (!strncmp(A, "lw", 2)) {
		if (DEBUG_INST)
			printf("PC: %d (%d) INST: \tnop\n", (PC+1)*4, PC+1);
		PC++;
	}	
	PC++;
}

/* 

PASS 2: Goes through the code again and replaces values

and generates the machine code

*/
/*Function that translate the code*/
void pass2(char pString[])
{  
    char machineCode[100];
    char A[100],B[100],C[100],D[100];
    int i = 0, j = 0, k = 0, absolute = 0;   
    int b,c,d;
    char binaryB[100],binaryC[100],binaryD[100];
    char binaryI[100], binaryI2[100], binaryI3[100], binaryJ[100];
    char BinaryO1[100], BinaryO2[100];
    char *ptr = NULL, *ptr2 = NULL;

    A[0]='\0';
    B[0]='\0';
    C[0]='\0';
    D[0]='\0';
 
    if (DEBUG) printf("Line: %s\n", pString);
    
    i=skip_spaces(pString,i);
    if (i && pString[i] == '.') return;

    i=extract(A,pString,i);
    i=extract(B,pString,i);
    i=extract(C,pString,i);
    i=extract(D,pString,i);
 
    ptr = strchr(C, '(');
    if (ptr) { // We are processing an offset like: 16($1)
	ptr2 = strchr(C, ')');
	*(ptr2) = 0;
	strncpy(D,C,(int)(ptr-C)); // Copy offset into D
	D[(ptr-C)] = 0;
	strncpy(C,ptr+1,(int)(ptr2-ptr)); // Copy the second half of the string into the first for register analysis
	C[(ptr2-ptr)] = 0;
    }    

    // Absolute PC substitution instead of offset
    if(!strncmp(A, "j", 1) || !strncmp(A, "jal", 3)) 
	absolute = 1;


    if (DEBUG) printf("A: %s B: %s C: %s D: %s\n", A,B,C,D);


    // GCC hax: Rewrite j $31 to jr $31?
    if (!strncmp(A, "j", 3) && !strncmp(B, "$31", 3)) {
	//if (DEBUG)
	printf("GCC hax, rewriting j $31 -> jr $31\n");
	sprintf(A, "jr");
    }
    // GCC hax2: Rewrite slt $2,$2,123 to slti $2,$2,123
    if (!strncmp(A, "slt", 3) && D[0] != '$') {
	printf("GCC hax2, rewriting slt %s,%s,%s to slti %s,%s,%s\n", B,C,D,B,C,D);
	sprintf(A, "slti");
    }
    // GCC hax3: We don't do arithemtic shifts, only logical
    if (!strncmp(A, "sra", 3)) {
	printf("GCC hax3, replacing sra with srl\n");
	sprintf(A, "srl");
    }
    if (!strncmp(A, "sla", 3)) {
	printf("GCC hax, replacing sla with sll\n");
	sprintf(A, "sll");
    }

    // GCC hax4: offsets divided by 4, we are dealing with word addressed memory and not byte addressed
//    if (!strncmp(A, "sw", 2) || !strncmp(A, "lw",2)) {
//	printf("GCC hax4, offsets fixed from %d to %d\n", atoi(D), atoi(D)/4);
//	sprintf(D, "%d", atoi(D)/4);
//    }

    RegisterRename(A,absolute);
    RegisterRename(B,absolute);
    RegisterRename(C,absolute);
    RegisterRename(D,absolute);
    
    b=atoi(B);
    dec2bin(b,binaryB,5);

    c=atoi(C);
    dec2bin(c,binaryC,5);

    if (D[0] == '0' && D[1] == 'x')
	sscanf(D, "%x", &d);
    else
    	d=atoi(D);

    dec2bin(d,binaryD,5);

    dec2bin(d,binaryI,16);

    dec2bin(c,binaryI2,16);
 
    dec2bin(b,binaryI3,16);

    dec2bin(b,binaryJ,26);

    //Offset(C,BinaryO1,BinaryO2);

    lowerCase(A);
    if(!strncmp(A, "sll", 3)) {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000","00000",binaryC,binaryB,binaryD,"000000");
       printToFile(machineCode);
    }
    if(!strncmp(A, "srl", 3)) {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000","00000",binaryC,binaryB,binaryD,"000010");
       printToFile(machineCode);
    }
    if(!strncmp(A, "add", 5))
    {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryC,binaryD,binaryB,"00000","100000");
       printToFile(machineCode);
    }
    if(!strncmp(A, "addi", 5))
    {
       snprintf(machineCode,33,"%s%s%s%s", "001000",binaryC,binaryB,binaryI);
       printToFile(machineCode);
    }    
    if(!strncmp(A, "addiu", 5))
    {
       snprintf(machineCode,33,"%s%s%s%s", "001001",binaryC,binaryB,binaryI);
       printToFile(machineCode);
    }   
    if(!strncmp(A, "addu", 5))
    {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryC,binaryD,binaryB,"00000","100001");
       printToFile(machineCode);
    }    
    if(!strncmp(A, "and", 4))
    {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryC,binaryD,binaryB,"00000","100100");
       printToFile(machineCode);
    }    
    if(!strncmp(A, "andi", 4))
    {
       snprintf(machineCode,33,"%s%s%s%s", "001100",binaryC,binaryB,binaryI);
       printToFile(machineCode);
    }   
    if(!strncmp(A, "beq", 3))
    {
       snprintf(machineCode,33,"%s%s%s%s", "000100",binaryB,binaryC,binaryI);
       printToFile(machineCode);
    }   
    else if(!strncmp(A, "bne", 3))
    {
       snprintf(machineCode,33,"%s%s%s%s", "000101",binaryB,binaryC,binaryI);
       printToFile(machineCode);
    }
    else if (!strncmp(A, "b", 1))
    {
       snprintf(machineCode,33,"%s%s%s%s", "000100","00000","00000",binaryI3);
       printToFile(machineCode);
    }
    if(!strncmp(A, "div", 4))
    {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryB,binaryC,"00000","00000","011010");
       printToFile(machineCode);
    }    
    if(!strncmp(A, "divu", 4))
    {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryB,binaryC,"00000","00000","011011");
       printToFile(machineCode);
    }  

    if(!strncmp(A, "jal", 3))
    {
       snprintf(machineCode,33,"%s%s","000011",binaryJ);
       printToFile(machineCode);
    }
    else if(!strncmp(A, "jr", 3))
    {
       snprintf(machineCode,33,"%s%s%s","000000",binaryB,"000000000000000001000");
       printToFile(machineCode);
    }
    else if(!strncmp(A, "j", 1))
    {
       snprintf(machineCode,33,"%s%s","000010",binaryJ);
       printToFile(machineCode);
    }   
    if(!strncmp(A, "mult", 5))
    {
       snprintf(machineCode,33,"%s%s%s%s","000000",binaryB,binaryC,"0000000000011000");
       printToFile(machineCode);
    }   
    if(!strncmp(A, "multu", 5))
    {
       snprintf(machineCode,33,"%s%s%s%s","000000",binaryB,binaryC,"0000000000011001");
       printToFile(machineCode);
    }
    if(!strncmp(A, "nop", 3))
    {
       snprintf(machineCode,33,"%s","00000000000000000000000000000000");
       printToFile(machineCode);
    }
    if(!strncmp(A, "or", 3))
    {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryC,binaryD,binaryB,"00000","100101");
       printToFile(machineCode);
    }
    if(!strncmp(A, "ori", 3))
    {
       snprintf(machineCode,33,"%s%s%s%s","001101",binaryC,binaryB,binaryI);
       printToFile(machineCode);
    }
    if (!strncmp(A, "sltu", 4))
    {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryC,binaryD,binaryB,"00000","101011");
       printToFile(machineCode);
    }
    else if(!strncmp(A, "sltiu", 5))
    {
       snprintf(machineCode,33,"%s%s%s%s","001011",binaryC,binaryB,binaryI);
       printToFile(machineCode);
    }
    else if(!strncmp(A, "slti", 4))
    {
       snprintf(machineCode,33,"%s%s%s%s","001010",binaryC,binaryB,binaryI);
       printToFile(machineCode);
    }
    else if (!strncmp(A, "slt", 3))
    {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryC,binaryD,binaryB,"00000","101010");
       printToFile(machineCode);
    }
    if(!strncmp(A, "sub", 4))
    {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryC,binaryD,binaryB,"00000","100010");
       printToFile(machineCode);
    }
    if(!strncmp(A, "subu", 4))
    {
       snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryC,binaryD,binaryB,"00000","100011");
       printToFile(machineCode);
    }
    if (!strncmp(A, "lw", 2))
    {
       snprintf(machineCode,33,"%s%s%s%s","100011",binaryC,binaryB,binaryI);
       printToFile(machineCode);
       snprintf(machineCode,33,"%s","00000000000000000000000000000000");
       printToFile(machineCode);
       PC++;
    }
    if (!strncmp(A, "sw", 2))
    {
       snprintf(machineCode,33,"%s%s%s%s","101011",binaryC,binaryB,binaryI);
       printToFile(machineCode);
    }
    /* HERE COME THE PSEUDO INSTRUCTIONS */
    if (!strncmp(A, "li", 2)) // Load immediate
    {
	snprintf(machineCode,33,"%s%s%s%s","001000","00000",binaryB,binaryI2);
	printToFile(machineCode);
    }
    if (!strncmp(A, "move", 4))
    {
	snprintf(machineCode,33,"%s%s%s%s%s%s","000000",binaryC,binaryD,binaryB,"00000","100000");
	printToFile(machineCode);
    }

    if (is_branch(A)) {
       snprintf(machineCode,33,"%s","00000000000000000000000000000000");
       printToFile(machineCode);
       printToFile(machineCode);
       printToFile(machineCode);
       PC += 3;
    }

    PC++;
}


/*Function that writes to file*/
printToFile(char pString[])
{
  FILE  *fp1 = fopen("outputFile", "a");
  fprintf(fp1,"%s",pString);
  fprintf(fp1,"\n");
  fclose (fp1);
}


void dec2bin(long decimal, char binary[], int length)
{
  int k = 0, n = 0, i = 0, clear=0;
  int remain;
  char temp[100];
  unsigned long dec2 = abs(decimal);
  if (decimal < 0) { // Do two's complement if it's negative
	dec2 = ~dec2;
	dec2++;
  }

  for (;clear<33;clear++)
  {
    binary[clear]='0';
  }

  do
  {
     remain = dec2 % 2;
     // whittle down the decimal number
     dec2 = dec2 / 2;
     // converts digit 0 or 1 to character '0' or '1'
     temp[k++] = remain + '0';
   } while (dec2 > 0);

   n=length-k;
   // reverse the spelling
   while (k >= 0)
      {
      	binary[n++] = temp[--k];
      }

   for (i;i<length;i++)
   {
      if(binary[i]!='0' && binary[i]!='1'){binary[i]='0';}
   }
   binary[length] = '\0'; // end with NULL
}

int extract(char A[], char pString[],int i)
{
   int j=0;
   while(pString[i]!='\0' && pString[i]!='\n' && (pString[i]==' ' || pString[i]=='\t' || pString[i]==',')){i++;}
   while(pString[i]!='\0' && pString[i]!='\n' && pString[i]!=' ' && pString[i]!='\t' && pString[i]!=',')
   {
      if(pString[i]=='#')
	{
		i=comment(pString,i);
		return i;
	}
      else if (pString[i] == ':') {
	LABEL_TABLE[labelcnt].PC = PC;
	strncpy(LABEL_TABLE[labelcnt].label, A, j);
	LABEL_TABLE[labelcnt].label[j] = '\0';
	labelcnt++;
	PC--; // Label line, decrement PC
      }
      A[j++]=pString[i++];
   }
   A[j]='\0';

   return i;
}

void RegisterRename(char A[], int absolute)   
{
   int j=0, offset=0;
   static char *regnames[] = {"r0", "at", "v0", "v1", "a0", "a1", "a2", "a3",
		    "t0", "t1", "t2", "t3", "t4", "t5", "t6", "t7",
		    "s0", "s1", "s2", "s3", "s4", "s5", "s6", "s7",
		    "t8", "t9", "k0", "k1", "gp", "sp", "s8", "ra"};

    for(j=0;j<MAX_LABELS;j++) {	
        if (strlen(A) > 0 && strlen(A) == strlen(LABEL_TABLE[j].label) && strncmp(LABEL_TABLE[j].label, A, strlen(A)) == 0) {
        	if (absolute)
			offset = LABEL_TABLE[j].PC;
		else
			offset = LABEL_TABLE[j].PC - PC - 1;
                if (DEBUG_LABELS) printf("PASS2: Found label '%s' at PC: %d with offset (absolute: %d): %d\n", A, PC, absolute, offset);
                sprintf(A,"%d",offset);
                return;
       }
    }

    j = 0;
    if(A[0]=='$')
    {
       while(A[j+1]!='\0')
       {
          A[j]=A[j+1];
	  j++;
       }
       A[j]='\0';
       if (strncmp(A, "zero",4) == 0) {
	sprintf(A, "0");
	return;
       } else if (strncmp(A, "fp",2) == 0) {
	sprintf(A, "30");
	return;
       }

       for(j=0;j<31;j++) {
       	if (strncmp(A,regnames[j],2) == 0) {
	 sprintf(A,"%d",j);
	 return;
	}
       }
    }
}

void lowerCase(char string[])
{
   int  i = 0;
   for ( ;i<99;i++ )
   {
      string[i] = tolower(string[i]);
   }
}


int comment(char pString[],int i)
{
   while(pString[i]!='\0' && pString[i]!='\n')
   {
   	i++;
   }
   return i;
}

void clearFile()
{
  remove("outputFile");
}

int skip_spaces(char A[], int i) {
  while (A[i] != '\0' && A[i] != '\n' && (A[i] == ' ' || A[i] == '\t')) i++;
  return i;
}
