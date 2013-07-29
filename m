From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 29 Jul 2013 11:06:06 +0300
Subject: [Ocfs2-devel] [PATCH v2] fs/ocfs2: use list_for_each_entry()
 instead of list_for_each()
In-Reply-To: <20130729074928.GB5053@mwanda>
References: <1374931429-14062-1-git-send-email-yp.fangdong@gmail.com>
	<20130729074928.GB5053@mwanda>
Message-ID: <20130729080606.GD5053@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dong Fang <yp.fangdong@gmail.com>
Cc: mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org, jeff.liu@oracle.com, viro@zeniv.linux.org.uk, sunil.mushran@gmail.com, tim.gardner@canonical.com, xuejiufei@huawei.com, shencanquan@huawei.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

Oh.  It appears that nothing changed between v1 and v2.  Only the CC
list.

It's probably that the list moderation on ocfs2-devel was confusing
for non-native English speakers the patch submitter thought his
patch was dropped.

Also mailing lists should have a white list so that I don't get the
message every single time.

regards,
dan carpenter
