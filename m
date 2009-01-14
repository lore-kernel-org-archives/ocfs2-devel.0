From: tristan.ye <tristan.ye@oracle.com>
Date: Wed, 14 Jan 2009 09:51:04 +0800
Subject: [Ocfs2-devel] [PATCH 0/5] OCFS2 quota fixes
In-Reply-To: <20090113111950.GA10064@duck.suse.cz>
References: <1231798833-6850-1-git-send-email-jack@suse.cz>
	<496C2E20.2040705@oracle.com>  <20090113111950.GA10064@duck.suse.cz>
Message-ID: <1231897864.6716.1.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 2009-01-13 at 12:19 +0100, Jan Kara wrote:
> Hello,
> 
> On Tue 13-01-09 14:01:04, tristan.ye wrote:
> > Jan Kara wrote:
> >> the following series of patches fixes some issues with OCFS2 quotas.
> >> The first patch modifies VFS quota locking, the next patch uses the
> >> fact to simplify OCFS2 quota locking and solves a few deadlock issues.
> >> The third and the fourth patches fix another possible deadlocks in OCFS2
> >> quota code and the last patch is a minor cleanup.
> >>   
> > Hi Jan,
> >
> > Would you like to show me the kernel tree/branch where your patches're 
> > going to be applied?
>   I've generated the patches against a master branch of Mark's git as of
> yesterday. But they aren't very intrusive so I guess they should apply also
> to other branches just fine.
> 
> > Btw, I'm also wondering if your latest patches which resolves some deadlock 
> > issues can also be applicable for bug 1043&1067(deadlock on inode removal) 
> > on bugzilla:
> > http://oss.oracle.com/bugzilla/show_bug.cgi?id=1043
>   Yes, they're exactly meant to solve these issues. I'm not able to trigger
> the deadlock with these patches anymore. I was to tired to update the
> bugzilla yesterday evening, I wanted to do it when Mark takes the patches.
> 
> > At last, It will be greatly appreciated if you can offer me your newly 
> > released quota-tools for OCFS2. Just simply attach the src tarball in 
> > replying mail is OK, or let me know the URL where your quota-tools for 
> > OCFS2 released:-)
>   You can download the source tarball from quota-tools Sourceforge pages:
> http://sourceforge.net/project/showfiles.php?group_id=18136&package_id=13522

The quota-tools above was not ocfs2-specific?  it's generic for both
ext3 and ocfs2? right?

Thanks,

Tristan

> 
> 									Honza
