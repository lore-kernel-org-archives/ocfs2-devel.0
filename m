From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 28 Mar 2017 15:31:46 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2: o2hb: revert hb threshold to keep
	compatible
In-Reply-To: <1490665245-15374-1-git-send-email-junxiao.bi@oracle.com>
References: <1490665245-15374-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <20170328153146.da60162a5a5d02c34cdd848e@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, 28 Mar 2017 09:40:45 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Configfs is the interface for ocfs2-tools to set configure to
> kernel. Change heartbeat dead threshold name in configfs will
> cause compatible issue, so revert it.
> 
> Fixes: 45b997737a80 ("ocfs2/cluster: use per-attribute show and store methods")

I don't get it.  45b997737a80 was merged nearly two years ago, so isn't
it a bit late to fix compatibility issues?
