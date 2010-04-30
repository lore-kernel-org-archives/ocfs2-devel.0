From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 30 Apr 2010 15:30:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: make lockres lookup faster
In-Reply-To: <20100430023906.GA2402@laptop.oracle.com>
References: <201004281649.o3S3tMKK007057@acsinet15.oracle.com>
	<4BD86CDB.8030702@oracle.com>
	<20100429093149.GA3082@laptop.oracle.com>
	<20100430023906.GA2402@laptop.oracle.com>
Message-ID: <20100430073018.GB2402@laptop.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

updates:

Checked the asm code, it's repeating calling cmpsb, which is a byte
operations, instead of cmpsw, which is an word opration. So a more cmpsb
means N more cpu clocks.

I replaced memcmp with strncmp, it gives us at most %50 improvement.

[wwg at cool src]$ ./a.out "1234567890123456789012345678901" "1234567890123456789012345678902" 10000 10000
0x8049a40 1234567890123456789012345678901 31
0x8049a60 1234567890123456789012345678902 31
loops 10000 x 10000
orig: 6s
fixed: 3s
[wwg at cool src]$ ./a.out "1234567890123456789012345678901" "1234567890123456789012345678902" 20000 10000
0x8049a40 1234567890123456789012345678901 31
0x8049a60 1234567890123456789012345678902 31
loops 20000 x 10000
orig: 12s
fixed: 6s
[wwg at cool src]$ ./a.out "1234567890123456789012345678901" "1234567890123456789012345678902" 40000 10000
0x8049a40 1234567890123456789012345678901 31
0x8049a60 1234567890123456789012345678902 31
loops 40000 x 10000
orig: 24s
fixed: 12s

So it saves at most 3s for 100,000,000 comparations, or 3ms for 100,000,
or 3us for 100, on my with Intel(R) Core(TM)2 Duo CPU E8400  @3.00GHz.
I have no idea whether this is much or little :P

So seems the user space strncmp() is making use of cmpsw as posible.
I checked kernel version memcmp/strcmp/strncmp, they are just using _byte_
operations.
So Why the kernel version functions are not optimized as in user space libs?
though we can't user strncmp instead of memcmp directly.

regards,
wengang.
On 10-04-30 10:39, Wengang Wang wrote:
> updates:
> 
> The test c file was not well written, so that the comparation is removed
> by the optimization. I retested and got following result:
> 
> [wwg at cool src]$ ./a.out "1234567890123456789012345678901"
> "1234567890123456789012345678902" 199999 9999
> 1234567890123456789012345678901 31
> 1234567890123456789012345678902 31
> loops 199999 x 9999
> loops 9999 199999
> orig cost 122s
> loops 9999 199999
> new cost 124s
> 
> That is after the change, it become slower. It's out of my thought :-(.
> Also with 32 long strs, it's slower.
> [wwg at cool src]$ ./a.out "12345678901234567890123456789010"
> "12345678901234567890123456789020" 29999 9999
> 12345678901234567890123456789010 32
> 12345678901234567890123456789020 32
> loops 29999 x 9999
> loops 9999 29999
> orig cost 18s
> loops 9999 29999
> new cost 19s
> 
> Attached the test c file.
> compiled with gcc -O2 2.c
> 
> regards,
> wengang.
> 
> On 10-04-29 17:31, Wengang Wang wrote:
> > Hi Sunil,
> > 
> > On 10-04-28 10:14, Sunil Mushran wrote:
> > > The dlm interface allows different sized locknames. And the locknames can be
> > > binary. That we use mostly ascii is just coincidental. Yes, mostly.
> > > The dentry
> > > lock is partially binary. Also, $RECOVERY is used only during recovery.
> > > 
> > > So the only interesting bit from my pov would be:
> > > 
> > > -		if (memcmp(res->lockname.name + 1, name + 1, len - 1))
> > > +		if (memcmp(res->lockname.name, name, len))
> > 
> > Yes, then it's the only bit. 
> > > Will just this change improve performance? How long a hash list would need
> > > to be for us to see an appreciable improvement?
> > I didn't do a test for only this bit, but for the whole change.
> > For the test I did the test c files are complied with no optimization.
> > 
> > I, just now, tested for only this bit with -O2 optimization, I can _not_ see
> > improvement for even a 1999999 x 99999 loops of comparation. So please
> > ignore this patch.
> > 
> > Compiled with no optimization, the comparation is done against each
> > charator one by one? It's funny.
> > 

> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/time.h>
> #include <string.h>
> 
> #define LOOPCNT 199999
> #define LOOPCNT2 9999
> unsigned char *name1 = "12345678901234567890123456789012";
> unsigned char *name2 = "12345678901234567890123456789012";
> unsigned int len1 = 32, len2 = 32;
> unsigned int loop1 = LOOPCNT, loop2 = LOOPCNT2;
> 
> int func1(unsigned int loop1, unsigned int loop2)
> {
> 	int i,j;
> 
> 	for (j = 0; j < loop1; j++) {
> 	for (i = 0; i < loop2; i++) {
> 		if (name1[0] != name2[0])
> 			continue;
> 		if (len1 != len2)
> 			continue;
> 		if (memcmp(name1 + 1, name2 + 1, len1 - 1))
> 			continue;
> 		break;
> 	}
> 	}
> 	printf("loops %d %d\n", i,j);
> 	return i + j;
> }
> int func2(unsigned int loop1, unsigned int loop2)
> {
> 	int i,j;
> 
> 	for (j = 0; j < loop1; j++) {
> 	for (i = 0; i < loop2; i++) {
> 		if (name1[0] != name2[0])
> 			continue;
> 		if (len1 != len2)
> 			continue;
> 		if (memcmp(name1, name2, len1))
> 			continue;
> 		break;
> 	}
> 	}
> 	printf("loops %d %d\n", i,j);
> 	return i + j;
> }
> 
> int main(int argc, char **argv)
> {
> 	int a;
> 	struct timeval timev1, timev2;
> 
> 	name1 = argv[1];
> 	name2 = argv[2];
> 	loop1 = atoi(argv[3]);
> 	loop2 = atoi(argv[4]);
> 	len1 = strlen(name1);
> 	len2 = strlen(name2);
> 	
> 	printf("%s %d\n", name1, len1);
> 	printf("%s %d\n", name2, len2);
> 	printf("loops %d x %d\n", loop1, loop2);
> 
> 	gettimeofday(&timev1, NULL);
> 	a = func1(loop1, loop2);
> 	gettimeofday(&timev2, NULL);
> 	printf("orig cost %lds\n", timev2.tv_sec - timev1.tv_sec);
> 	gettimeofday(&timev1, NULL);
> 	a += func2(loop1, loop2);
> 	gettimeofday(&timev2, NULL);
> 	printf("new cost %lds\n", timev2.tv_sec - timev1.tv_sec);
> 	return a;
> }
> 
