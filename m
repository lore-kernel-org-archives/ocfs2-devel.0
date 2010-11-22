From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Mon, 22 Nov 2010 16:21:54 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlm: check lockres owner in handler
 path
In-Reply-To: <201011190658.oAILihmm013474@acsinet15.oracle.com>
References: <201011190658.oAILihmm013474@acsinet15.oracle.com>
Message-ID: <20101122082154.GD3326@laptop.jp.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10-11-19 14:56, Wengang Wang wrote:
> We have check lockres owner in handler path because the owner can change
> during that time.
> 
> In case this node is in progress of unmount, it does migrations with
> other node. If one of the migration target get crashed before the
> migration finishes, recovery happens on this lockres. If this node is
> not the (dlm) recovery master, it can lost the ownership.
> On the other hand, in case another node is in progress of migration, and
> this node is not the target. if the node doing unmount crashed,  This
> node can gain the ownership if it becomes the recovery master.
> So we should take care the above cases.
> Also the ownership can move between two other different nodes. We
> don't care that.

With this patch, by not sending request to wrong master node, maybe we can avoid
some "invalid lockres id" problem if not all.

regards,
wengang.
