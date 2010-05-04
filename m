From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 03 May 2010 17:14:49 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: make lockres lookup faster
In-Reply-To: <20100430073018.GB2402@laptop.oracle.com>
References: <201004281649.o3S3tMKK007057@acsinet15.oracle.com>
	<4BD86CDB.8030702@oracle.com>
	<20100429093149.GA3082@laptop.oracle.com>
	<20100430023906.GA2402@laptop.oracle.com>
	<20100430073018.GB2402@laptop.oracle.com>
Message-ID: <4BDF66F9.2070504@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 04/30/2010 12:30 AM, Wengang Wang wrote:
> updates:
>
> Checked the asm code, it's repeating calling cmpsb, which is a byte
> operations, instead of cmpsw, which is an word opration. So a more cmpsb
> means N more cpu clocks.
>
> I replaced memcmp with strncmp, it gives us at most %50 improvement.
>
> [wwg at cool src]$ ./a.out "1234567890123456789012345678901" "1234567890123456789012345678902" 10000 10000
> 0x8049a40 1234567890123456789012345678901 31
> 0x8049a60 1234567890123456789012345678902 31
> loops 10000 x 10000
> orig: 6s
> fixed: 3s
> [wwg at cool src]$ ./a.out "1234567890123456789012345678901" "1234567890123456789012345678902" 20000 10000
> 0x8049a40 1234567890123456789012345678901 31
> 0x8049a60 1234567890123456789012345678902 31
> loops 20000 x 10000
> orig: 12s
> fixed: 6s
> [wwg at cool src]$ ./a.out "1234567890123456789012345678901" "1234567890123456789012345678902" 40000 10000
> 0x8049a40 1234567890123456789012345678901 31
> 0x8049a60 1234567890123456789012345678902 31
> loops 40000 x 10000
> orig: 24s
> fixed: 12s
>
> So it saves at most 3s for 100,000,000 comparations, or 3ms for 100,000,
> or 3us for 100, on my with Intel(R) Core(TM)2 Duo CPU E8400  @3.00GHz.
> I have no idea whether this is much or little :P
>
>    

We have 16K hash buckets. 100 each means there are 1.6 million lock 
resources.
 From what I have seen, users have 0.5 to 1 million active lock 
resources.  Now
consider the fact that a message round trip on a gige takes something around
100-150us. Saving 3us is not going to get us much.
