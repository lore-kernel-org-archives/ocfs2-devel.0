From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 26 Jun 2013 14:49:39 -0700
Subject: [Ocfs2-devel] [PATCH V2] ocfs2: need rollback when
 journal_access failed in ocfs2_orphan_add()
In-Reply-To: <51C2B662.2000206@huawei.com>
References: <51C2B662.2000206@huawei.com>
Message-ID: <20130626144939.7c0a916c3bd507b3c6926e6a@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 20 Jun 2013 15:59:30 +0800 Younger Liu <younger.liu@huawei.com> wrote:

> While adding a file into orphan dir in ocfs2_orphan_add(),
> it calls __ocfs2_add_entry() before ocfs2_journal_access_di(). 
> If ocfs2_journal_access_di() failed, the file is added into 
> orphan dir, and orphan dir dinode updated, but file dinode 
> has not been updated.
> Accordingly, the data is not consistent between file dinode 
> and orphan dir.
> 
> So, need to call ocfs2_journal_access_di() before __ocfs2_add_entry(),
> and if ocfs2_journal_access_di() failed, orphan_fe and 
> orphan_dir_inode->i_nlink need rollback. 
> 
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -2012,6 +2012,21 @@ static int ocfs2_orphan_add(struct ocfs2_super *osb,

ocfs2_orphan_add() will call mlog_errno(status) two times for the same
error in many cases.  That's not a big problem, but is sloppy and asks
for a cleanup.
