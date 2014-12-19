From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 19 Dec 2014 14:15:13 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix the wrong directory passed to
 ocfs2_lookup_ino_from_name() when link file
In-Reply-To: <5493F8F1.3020602@huawei.com>
References: <5493F8F1.3020602@huawei.com>
Message-ID: <20141219141513.d68d5737c625c1b188004c89@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, 19 Dec 2014 18:07:45 +0800 Xue jiufei <xuejiufei@huawei.com> wrote:

> In function ocfs2_link(), parent directory inode passed to function
> ocfs2_lookup_ino_from_name() is wrong. Parameter dir is the parent
> of new_dentry not old_dentry. We should get old_dir from old_dentry
> and lookup old_dentry in old_dir in case another node remove the old dentry.

What are the user-visible effects of this change?
