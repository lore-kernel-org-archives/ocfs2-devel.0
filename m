From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 9 Apr 2015 22:46:53 +0300
Subject: [Ocfs2-devel] vfs: Add general support to enforce project quota
	limits
In-Reply-To: <20150409193954.GA19913@mwanda>
References: <20150409193954.GA19913@mwanda>
Message-ID: <20150409194653.GE16501@mwanda>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Here is a related warning.  I haven't investigated it.

fs/quota/quota_v1.c:149 v1_check_quota_file() error: buffer overflow 'quota_magics' 2 <= 2

regards,
dan carpenter
