From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Fri, 28 Aug 2009 10:12:45 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: adds mlogs to aops.c -V3
In-Reply-To: <20090828011018.GG18962@mail.oracle.com>
References: <200908140604.n7E64rhS031970@acsinet15.oracle.com>
	<20090828011018.GG18962@mail.oracle.com>
Message-ID: <4A973D1D.70500@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

in fact, I had ever hit case that ocfs2 returns EIO, but even allowing 
ENTRY/EXIT, there is no log indicating that.. the bug number is 8627756.

So I think we'd better add the logs to such functions. and added them 
for the functions in aops.c(seems that Sunil wants to add logs to that 
file)...

and for the patch its self, I think the log contents are for developers 
to check(not for customer to view), so we can know what are printed by 
checking the src... so I am printing some parameters without pointing 
out what they are.

regards,
wengang.

Joel Becker wrote:
> On Fri, Aug 14, 2009 at 02:02:39PM +0800, Wengang Wang wrote:
>> this patch adds some mlogs to apos.c helping tracing and narrowing down bugs.
> 
> Wengang,
> 	Have these traces been of use to you, or are you just adding
> some entry/exit traces because you see functions without them?
> 
> Joel
> 
