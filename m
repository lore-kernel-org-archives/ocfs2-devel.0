From: Mark Fasheh <mfasheh@suse.com>
Date: Thu, 10 Mar 2011 13:21:30 -0800
Subject: [Ocfs2-devel] [PATCH] Ocfs2: do not allow fallocate on dir file
In-Reply-To: <AANLkTin02+WQ-uH373PNB3ME5X=miq6RzHGOSLkbKP+N@mail.gmail.com>
References: <201103041510.33128.lidongyang@novell.com>
	<20110309230132.GF1703@wotan.suse.de>
	<4D783728.3070307@oracle.com> <4D783B89.7090603@tao.ma>
	<20110310042549.GG1703@wotan.suse.de>
	<AANLkTimyFzy0yx_tYpAbxk7rMq3kZr5=+MJH-5=pJOaH@mail.gmail.com>
	<20110310165404.GH1703@wotan.suse.de>
	<AANLkTin02+WQ-uH373PNB3ME5X=miq6RzHGOSLkbKP+N@mail.gmail.com>
Message-ID: <20110310212129.GI1703@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 11, 2011 at 02:33:41AM +0800, Jiaju Zhang wrote:
> On Fri, Mar 11, 2011 at 12:54 AM, Mark Fasheh <mfasheh@suse.com> wrote:
> > On Thu, Mar 10, 2011 at 02:00:33PM +0800, Jiaju Zhang wrote:
> >> On Thu, Mar 10, 2011 at 12:25 PM, Mark Fasheh <mfasheh@suse.com> wrote:
> >> > On Thu, Mar 10, 2011 at 10:46:33AM +0800, Tao Ma wrote:
> >> >> On 03/10/2011 10:27 AM, Sunil Mushran wrote:
> >> >> > On 03/09/2011 03:01 PM, Mark Fasheh wrote:
> >> >> >> On Fri, Mar 04, 2011 at 03:10:33PM +0800, Li Dongyang wrote:
> >> >> >>> @@ -1870,6 +1870,11 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
> >> >> >>> ? ? ? ? ? ? ? ? ? goto out_inode_unlock;
> >> >> >>> ? ? ? ? ? }
> >> >> >>>
> >> >> >>> + if (!S_ISREG(inode->i_mode)) {
> >> >> >>> + ? ? ? ? ret = -EINVAL;
> >> >> >>> + ? ? ? ? goto out_inode_unlock;
> >> >> >>> + }
> >> >> >> You might want to move the check into ocfs2_fallocate to mirror what
> >> >> >> ocfs2_change_file_space() does. Otherwise, looks like a good catch.
> >> >> >>
> >> >> >
> >> >> > Tristan pointed out that this check was already in ocfs2_change_file_space().
> >> >> > So this patch should not be required. Am I missing something?
> >> >> This patch is needed since the check is in ocfs2_change_file_space. But
> >> >> ocfs2_fallocate calls __ocfs2_change_file_space directly.
> >> >
> >> > Right.
> >>
> >> It seems it is not right:-) If I read the code correctly, although
> >> ocfs2_fallocate calls __ocfs2_change_file_space directly, however,
> >> ocfs2_fallocate is a file operation but not an inode operation,
> >> ocfs2_fallocate can only be registered when that file is a regular
> >> file, so this patch is not needed.
> >
> > Please review the code in fs/open.c:do_fallocate()
> >
> > ? ? ? ?/*
> > ? ? ? ? * Let individual file system decide if it supports preallocation
> > ? ? ? ? * for directories or not.
> > ? ? ? ? */
> > ? ? ? ?if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
> > ? ? ? ? ? ? ? ?return -ENODEV;
> 
> Yes.
> 
> >
> > So, sys_fallocate is leaving the decision up to the file system. Therefore I
> > think your patch is needed after all :)
> 
> Maybe I haven't said more clear about this :-) I mean the check has
> been performed before, please see the code in fs/ocfs2/inode.c
> <<ocfs2_populate_inode>>:

Ahh ok. I see - we never set the fallocate callback on directory inodes in
the first place. Disregard my previous e-mails then!
	--Mark

Mark Fasheh
