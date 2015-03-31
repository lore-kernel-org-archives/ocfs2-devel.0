From: jiangyiwen <jiangyiwen@huawei.com>
Date: Tue, 31 Mar 2015 11:23:05 +0800
Subject: [Ocfs2-devel]  Question about ocfs2_rename
Message-ID: <551A1319.50708@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
In the function of ocfs2_rename, there is a comment before
ocfs2_find_entry(old_dentry):
/*
 * Now that the name has been added to new_dir, remove the old name.
 *
 * We don't keep any directory entry context around until now
 * because the insert might have changed the type of directory
 * we're dealing with.
 */
I don't understand the meaning of this comment. The main problems
are as follows:
1) I think in this flow, we will delete old directory entry,
but what does "the insert" refer to?
2) what does "the type of directory we're dealing with" mean?
why it might be changed?

I've studied the flow of ext4_rename and have not found
such process or scenario. So I'm confused whether we may
call ocfs2_fine_entry(old_entry) before ...

Thanks,
Yiwen Jiang
