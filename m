From: Massimo "CtRiX" Cetra <ctrix@navynet.it>
Date: Mon, 12 Oct 2009 17:07:00 +0200
Subject: [Ocfs2-devel] [Bug #14378] Problems with net/core/skbuff.c
In-Reply-To: <20091012.034224.64980795.davem@davemloft.net>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>	<r-4Wjt4coy.A.CwC.Wal0KB@chimera>
	<20091012.034224.64980795.davem@davemloft.net>
Message-ID: <4AD34614.6070701@navynet.it>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, kernel-testers@vger.kernel.org

David Miller ha scritto:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Mon, 12 Oct 2009 00:22:04 +0200 (CEST)
> 
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14378
>> Subject		: Problems with net/core/skbuff.c
>> Submitter	: Massimo Cetra <mcetra@navynet.it>
>> Date		: 2009-10-08 14:51 (4 days old)
>> References	: http://marc.info/?l=linux-kernel&m=125501488220358&w=4
> 
> I don't know what to do about this one.
> 
> The user indicates that they have the vserver patches applied,
> so maybe there is some interaction with that stuff.

Actually i don't think that it's Vserver related.

I'm not a kernel hacker but the vserver patch doesn't seems to have much 
relation with networking (for who don't know vserver, it's a sort of 
advanced chroot).

I'm using OCFS2 and drbd. Both of those 2 things make heavy use of 
networking to share data between two hosts.

The backtrace seems to begin in the "world" of OFCS2.
I'm CC'ing ocfs mailing list where someome may have some clues.

Thanks,
Max
