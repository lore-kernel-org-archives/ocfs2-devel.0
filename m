From: Jiaju Zhang <jjzhang.linux@gmail.com>
Date: Thu, 10 Mar 2011 14:00:33 +0800
Subject: [Ocfs2-devel] [PATCH] Ocfs2: do not allow fallocate on dir file
In-Reply-To: <20110310042549.GG1703@wotan.suse.de>
References: <201103041510.33128.lidongyang@novell.com>
	<20110309230132.GF1703@wotan.suse.de> <4D783728.3070307@oracle.com>
	<4D783B89.7090603@tao.ma> <20110310042549.GG1703@wotan.suse.de>
Message-ID: <AANLkTimyFzy0yx_tYpAbxk7rMq3kZr5=+MJH-5=pJOaH@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 10, 2011 at 12:25 PM, Mark Fasheh <mfasheh@suse.com> wrote:
> On Thu, Mar 10, 2011 at 10:46:33AM +0800, Tao Ma wrote:
>> On 03/10/2011 10:27 AM, Sunil Mushran wrote:
>> > On 03/09/2011 03:01 PM, Mark Fasheh wrote:
>> >> On Fri, Mar 04, 2011 at 03:10:33PM +0800, Li Dongyang wrote:
>> >>> @@ -1870,6 +1870,11 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
>> >>> ? ? ? ? ? ? ? ? ? goto out_inode_unlock;
>> >>> ? ? ? ? ? }
>> >>>
>> >>> + if (!S_ISREG(inode->i_mode)) {
>> >>> + ? ? ? ? ret = -EINVAL;
>> >>> + ? ? ? ? goto out_inode_unlock;
>> >>> + }
>> >> You might want to move the check into ocfs2_fallocate to mirror what
>> >> ocfs2_change_file_space() does. Otherwise, looks like a good catch.
>> >>
>> >
>> > Tristan pointed out that this check was already in ocfs2_change_file_space().
>> > So this patch should not be required. Am I missing something?
>> This patch is needed since the check is in ocfs2_change_file_space. But
>> ocfs2_fallocate calls __ocfs2_change_file_space directly.
>
> Right.

It seems it is not right:-) If I read the code correctly, although
ocfs2_fallocate calls __ocfs2_change_file_space directly, however,
ocfs2_fallocate is a file operation but not an inode operation,
ocfs2_fallocate can only be registered when that file is a regular
file, so this patch is not needed.

Thanks,
Jiaju

>
>
>> So maybe we should add the check here and remove the check in
>> ocfs2_change_file_space?
>
> Either way works for me.
> ? ? ? ?--Mark
>
> --
> Mark Fasheh
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
