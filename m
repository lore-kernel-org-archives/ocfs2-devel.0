From: Zach Brown <zach.brown@oracle.com>
Date: Thu, 14 Feb 2008 16:53:57 -0000
Subject: [Ocfs2-devel] [PATCH] o2net: Reconnect after idle time out.V2
In-Reply-To: <20080214023137.GA14136@tma-pc1.cn.oracle.com>
References: <20080214023137.GA14136@tma-pc1.cn.oracle.com>
Message-ID: <47B47204.400@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tao Ma wrote:
> Modification from V1 to V2:
> 1. Use atomic ops instead of spin_lock in timer.
> 2. Add some comments when querying connect_expired work.
>    These comments are copied form Zach's mail.;)

:)

This looks OK to me, thanks for updating it.

- z
