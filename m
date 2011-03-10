From: Jiaju Zhang <jjzhang.linux@gmail.com>
Date: Fri, 11 Mar 2011 02:33:41 +0800
Subject: [Ocfs2-devel] [PATCH] Ocfs2: do not allow fallocate on dir file
In-Reply-To: <20110310165404.GH1703@wotan.suse.de>
References: <201103041510.33128.lidongyang@novell.com>
	<20110309230132.GF1703@wotan.suse.de> <4D783728.3070307@oracle.com>
	<4D783B89.7090603@tao.ma> <20110310042549.GG1703@wotan.suse.de>
	<AANLkTimyFzy0yx_tYpAbxk7rMq3kZr5=+MJH-5=pJOaH@mail.gmail.com>
	<20110310165404.GH1703@wotan.suse.de>
Message-ID: <AANLkTin02+WQ-uH373PNB3ME5X=miq6RzHGOSLkbKP+N@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 11, 2011 at 12:54 AM, Mark Fasheh <mfasheh@suse.com> wrote:
> On Thu, Mar 10, 2011 at 02:00:33PM +0800, Jiaju Zhang wrote:
>> On Thu, Mar 10, 2011 at 12:25 PM, Mark Fasheh <mfasheh@suse.com> wrote:
>> > On Thu, Mar 10, 2011 at 10:46:33AM +0800, Tao Ma wrote:
>> >> On 03/10/2011 10:27 AM, Sunil Mushran wrote:
>> >> > On 03/09/2011 03:01 PM, Mark Fasheh wrote:
>> >> >> On Fri, Mar 04, 2011 at 03:10:33PM +0800, Li Dongyang wrote:
>> >> >>> @@ -1870,6 +1870,11 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>> >> >>> ? ? ? ? ? ? ? ? ? goto out_inode_unlock;
>> >> >>> ? ? ? ? ? }
>> >> >>>
>> >> >>> + if (!S_ISREG(inode->i_mode)) {
>> >> >>> + ? ? ? ? ret = -EINVAL;
>> >> >>> + ? ? ? ? goto out_inode_unlock;
>> >> >>> + }
>> >> >> You might want to move the check into ocfs2_fallocate to mirror what
>> >> >> ocfs2_change_file_space() does. Otherwise, looks like a good catch.
>> >> >>
>> >> >
>> >> > Tristan pointed out that this check was already in ocfs2_change_file_space().
>> >> > So this patch should not be required. Am I missing something?
>> >> This patch is needed since the check is in ocfs2_change_file_space. But
>> >> ocfs2_fallocate calls __ocfs2_change_file_space directly.
>> >
>> > Right.
>>
>> It seems it is not right:-) If I read the code correctly, although
>> ocfs2_fallocate calls __ocfs2_change_file_space directly, however,
>> ocfs2_fallocate is a file operation but not an inode operation,
>> ocfs2_fallocate can only be registered when that file is a regular
>> file, so this patch is not needed.
>
> Please review the code in fs/open.c:do_fallocate()
>
> ? ? ? ?/*
> ? ? ? ? * Let individual file system decide if it supports preallocation
> ? ? ? ? * for directories or not.
> ? ? ? ? */
> ? ? ? ?if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
> ? ? ? ? ? ? ? ?return -ENODEV;

Yes.

>
> So, sys_fallocate is leaving the decision up to the file system. Therefore I
> think your patch is needed after all :)

Maybe I haven't said more clear about this :-) I mean the check has
been performed before, please see the code in fs/ocfs2/inode.c
<<ocfs2_populate_inode>>:

 322         switch (inode->i_mode & S_IFMT) {
 323             case S_IFREG:
 324                     if (use_plocks)
 325                             inode->i_fop = &ocfs2_fops;
 326                     else
 327                             inode->i_fop = &ocfs2_fops_no_plocks;
 328                     inode->i_op = &ocfs2_file_iops;
 329                     i_size_write(inode, le64_to_cpu(fe->i_size));
 330                     break;
 331             case S_IFDIR:
 332                     inode->i_op = &ocfs2_dir_iops;
 333                     if (use_plocks)
 334                             inode->i_fop = &ocfs2_dops;
 335                     else
 336                             inode->i_fop = &ocfs2_dops_no_plocks;
 337                     i_size_write(inode, le64_to_cpu(fe->i_size));
 338                     OCFS2_I(inode)->ip_dir_lock_gen = 1;
 339                     break;

In line 323, we have checked the inode->i_mode, if it is S_IFREG,
ocfs2_fops will be assigned to inode->i_fop; if it is S_IFDIR,
ocfs2_dops should be assigned. And from the code in fs/ocfs2/file.c:

2626 const struct file_operations ocfs2_fops = {
2627         .llseek         = generic_file_llseek,
2628         .read           = do_sync_read,
2629         .write          = do_sync_write,
2630         .mmap           = ocfs2_mmap,
2631         .fsync          = ocfs2_sync_file,
2632         .release        = ocfs2_file_release,
2633         .open           = ocfs2_file_open,
2634         .aio_read       = ocfs2_file_aio_read,
2635         .aio_write      = ocfs2_file_aio_write,
2636         .unlocked_ioctl = ocfs2_ioctl,
2637 #ifdef CONFIG_COMPAT
2638         .compat_ioctl   = ocfs2_compat_ioctl,
2639 #endif
2640         .lock           = ocfs2_lock,
2641         .flock          = ocfs2_flock,
2642         .splice_read    = ocfs2_file_splice_read,
2643         .splice_write   = ocfs2_file_splice_write,
2644         .fallocate      = ocfs2_fallocate,
2645 };
2646
2647 const struct file_operations ocfs2_dops = {
2648         .llseek         = generic_file_llseek,
2649         .read           = generic_read_dir,
2650         .readdir        = ocfs2_readdir,
2651         .fsync          = ocfs2_sync_file,
2652         .release        = ocfs2_dir_release,
2653         .open           = ocfs2_dir_open,
2654         .unlocked_ioctl = ocfs2_ioctl,
2655 #ifdef CONFIG_COMPAT
2656         .compat_ioctl   = ocfs2_compat_ioctl,
2657 #endif
2658         .lock           = ocfs2_lock,
2659         .flock          = ocfs2_flock,
2660 };

ocfs2_fops has the fallocate field, but ocfs2_dops doesn't have it. So
if the file is a directory, file->f_op->fallocate should be NULL, so
in the function do_fallocate, it should have returned -EOPNOTSUPP
already. So I think that check is not needed. Or am I missing
something?:)

Thanks,
Jiaju
