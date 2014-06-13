From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Fri, 13 Jun 2014 09:56:54 +0800
Subject: [Ocfs2-devel] ocfs2: o2net: fix packets lost issue when
	reconnect
In-Reply-To: <1402624104-17841-1-git-send-email-junxiao.bi@oracle.com>
References: <1402624104-17841-1-git-send-email-junxiao.bi@oracle.com>
Message-ID: <539A5A66.2080306@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Not sure why Joseph Qi is excluded from cc list of git send-email.
Cc him.

On 06/13/2014 09:48 AM, Junxiao Bi wrote:
>
> Hi,
>
> This patch serial is to fix a possible message lost bug in ocfs2 when
> network go bad. This bug will cause ocfs2 hung forever even network
> become good again.
> The messages may lost in this case. After the tcp connection is established
> between two nodes, an idle timer will be set to check its state periodically,
> if no messages are received during this time, idle timer will timeout, it will
> shutdown the connection and try to reconnect, so pending messages in tcp queues
> will be lost. This messages may be from dlm. Dlm may get hung in this case. This
> may cause the whole ocfs2 cluster hung. 
> This is very possible to happen when network state goes bad. Do the reconnect is
> useless, it will fail if network state is still bad. Just waiting there for
> network recovering may be a good idea, it will not lost messages and some node
> will be fenced until cluster goes into split-brain state, for this case, Tcp user
> timeout is used to override the tcp retransmit timeout. It will timeout after 25
> days, user should have notice this through the provided log and fix the network,
> if they don't, ocfs2 will fall back to original reconnect way.
> This is a resend of the patches, no changes since last time. Please help review.
>
> Thanks,
> Junxiao.
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
