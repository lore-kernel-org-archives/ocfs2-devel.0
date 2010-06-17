From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Thu, 17 Jun 2010 14:05:31 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <4C197E0B.1060103@oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<4C197E0B.1060103@oracle.com>
Message-ID: <20100617060531.GA2477@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-06-16 18:44, Sunil Mushran wrote:
> One way to skip a lockres in the purgelist is to list_del_init() and
> list_add_tail(). That simplifies the patch a lot.

For my knowledge, why not just list_move_tail()?

regards,
wengang. 
