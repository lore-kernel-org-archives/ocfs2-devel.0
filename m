From: Joel Becker <jlbec@evilplan.org>
Date: Sat, 29 Jun 2013 14:28:36 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: llseek requires to ocfs2 inode
 lock for the file in SEEK_END
In-Reply-To: <51CD533D.9030503@oracle.com>
References: <51C2BC1F.2010106@huawei.com>
	<20130626141803.a67cb8e4ca38a9ef2967a448@linux-foundation.org>
	<51CB9338.3050408@huawei.com>
	<20130626182536.c319334d.akpm@linux-foundation.org>
	<51CB9A81.2000007@huawei.com>
	<CAEeiSHV=3DBBJ1mweEgyxWRgsA9O8C-25_FTPMxyDbatoX0Fkw@mail.gmail.com>
	<20130627150810.2d22d158a1f0bed8482a27d8@linux-foundation.org>
	<CAEeiSHVeTCsQizasNNxAeYwfJt9EyWb_CgjNwyGFwTWGm5NuxQ@mail.gmail.com>
	<51CD533D.9030503@oracle.com>
Message-ID: <20130629132836.GK13405@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jun 28, 2013 at 05:11:25PM +0800, Jeff Liu wrote:
> On 06/28/2013 06:59 AM, Sunil Mushran wrote:
> 
> > The qs is whether this change is required for a real problem or not. If
> > so, what is that logic
> > that gets tripped up by this behaviour.

This is a straight correctness fix.  We take the hit and apply it.  I'll
check the actual patch on that email.

Joel

> 
> 
> IMHO, there have a couple of commands in Coreutils would be affected by this
> behavior:
> - tail(1) with "-c bytes" option.
> - wc(1): when counting only bytes, it will try to figure out the file size
> 	 through lseek (SEEK_END - SEEK_CUR) when counting only bytes.
> 
> Other popular programs need get the file size via SEEK_END only in some corner
> cases.  e.g, if the input file is not a regular file or the utility failed to
> fetch the file size via fstat(2), they will call lseek as an alternative approach,
> like split(1), truncate(1), head(1) with '-c bytes' option.
> 
> Generally, the user applications might fetch the file size through fstat(2) which
> will go through ocfs2_getattr() so that it's safe to us because we perform inode
> re-validation before filling up the generic attributes.
> 
> IOWs, the user application could be changed accordingly to avoid this issue.
> However, this most likely a workaround to some extent, and we have a bug for
> the SEEK_END business.
> 
> As per our current discussion, one big concern of us is regarding the performance
> with this fix, I'd like to consider it from another point of view, that is the user
> should take all the blame to themselves if they would like to run SEEK_END bounds
> operation on OCFS2, does it sounds make sense? :-P.
> If yes, it would be better to consolidate the code comments to indicate the
> performance negatively and it is not advisable to fetch file size via SEEK_END
> on OCFS2.
> 
> Thanks,
> -Jeff
> 
> > 
> > 
> > On Thu, Jun 27, 2013 at 3:08 PM, Andrew Morton
> > <akpm at linux-foundation.org <mailto:akpm@linux-foundation.org>> wrote:
> > 
> >     On Wed, 26 Jun 2013 20:34:19 -0700 Sunil Mushran
> >     <sunil.mushran at gmail.com <mailto:sunil.mushran@gmail.com>> wrote:
> > 
> >     > AFAIR, this behavior has been there since day 1 and changing it
> >     will impact
> >     > performance negatively. I would recommend against making this
> >     change for
> >     > one app.
> > 
> >     Well, it's a bug fix isn't it?  SEEK_END on a 15k file is presently
> >     returning
> >     10k.
> > 
> >     Obviously tradeoffs are involved - is there any way in which this
> >     behaviour can be fixed without serious performance damage?
> > 
> > 
> > 
> > 
> > _______________________________________________
> > Ocfs2-devel mailing list
> > Ocfs2-devel at oss.oracle.com
> > https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

-- 
