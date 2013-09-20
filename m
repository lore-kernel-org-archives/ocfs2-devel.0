From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 20 Sep 2013 13:56:42 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: ocfs2 dlm umount skip
 migrating lockres
In-Reply-To: <52313C54.3090600@oracle.com>
References: <1378924830-16356-1-git-send-email-tariq.x.saeed@oracle.com>
	<523121CD.2040000@huawei.com> <52313C54.3090600@oracle.com>
Message-ID: <20130920135642.c781dc5135dbe54b7fdca8ef@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, 11 Sep 2013 21:00:20 -0700 Srinivas Eeda <srinivas.eeda@oracle.com> wrote:

> Andrew,
> can you please pull the following patch acked by Sunil and Joel
> 
> https://oss.oracle.com/pipermail/ocfs2-devel/2012-August/008670.html

Yup.  I just went through Joel's old linux-next tree and stole
everything from it:

From: Joel Becker <jlbec@evilplan.org>
Subject: ocfs2: don't spam on -EDQUOT

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ocfs2: use bitmap_weight()

From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: skip locks in the blocked list

From: Xue jiufei <xuejiufei@huawei.com>
Subject: ocfs2: delay migration when the lockres is in migration state

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ocfs2: use find_last_bit()

From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: break useless while loop
