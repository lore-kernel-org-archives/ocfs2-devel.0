From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 13 Jan 2012 14:08:17 -0800
Subject: [Ocfs2-devel] pull request
Message-ID: <4F10AB51.5080402@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel,

Please pull 6 patches (bug fixes) from the following repo.

git://oss.oracle.com/git/smushran/linux-2.6.git  mw-3.3-jan13

BTW, not sure if I emailed before but we have to rollback 3 patches
related to deletes. These patches were added to fix deadlocks with
quotas. Well, it has just broken deletes. Srini has the list. We'll
have to find another way to fix the quotas deadlock.

Sunil

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20120113/d06b51bc/attachment.html 
