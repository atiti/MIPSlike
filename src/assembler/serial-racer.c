int main() {
	int wp = 8;
	int wd = 1;
	int l = 0;	
	int a = 0;

	while (1) {
		a = get_chr();
		for(l=0;l<40;l++) {
			if (l < wp || l > (40-wp))
				put_chr('-');
			else
				put_chr('#');
		}
		if (wd)
			wp++;
		else
			wp--;

		if (wp > 14 || wp < 4) {
			if (wd)
				wd = 0;
			else
				wd = 1;
		}

	}
	return 0;
}
