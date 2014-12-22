From: Aron Szabo <aron@ubit.hu>
Date: Mon, 22 Dec 2014 09:52:14 +0100
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix the wrong directory passed to
 ocfs2_lookup_ino_from_name() when link file
In-Reply-To: <20141219141513.d68d5737c625c1b188004c89@linux-foundation.org>
References: <5493F8F1.3020602@huawei.com>
	<20141219141513.d68d5737c625c1b188004c89@linux-foundation.org>
Message-ID: <5497DBBE.7060700@ubit.hu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Andew!

Hard linking works again, when paths are relative with at least one 
subdirectory. This is how the problem was reproducable:

# mkdir a
# mkdir b
# touch a/test
# ln a/test b/test
ln: failed to create hard link `b/test' => `a/test': No such file or 
directory

However when creating links in the same dir, it worked well.

Now the link gets created.

Thanks for the quick fix Xue!

Yours,
Aron

12/19/2014 11:15 PM keltez?ssel, Andrew Morton ?rta:
> On Fri, 19 Dec 2014 18:07:45 +0800 Xue jiufei <xuejiufei@huawei.com> wrote:
>
>> In function ocfs2_link(), parent directory inode passed to function
>> ocfs2_lookup_ino_from_name() is wrong. Parameter dir is the parent
>> of new_dentry not old_dentry. We should get old_dir from old_dentry
>> and lookup old_dentry in old_dir in case another node remove the old dentry.
> What are the user-visible effects of this change?

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20141222/0cf52b56/attachment.html 
