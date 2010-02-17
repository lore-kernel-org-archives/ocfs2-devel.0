From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 16 Feb 2010 21:56:41 -0800
Subject: [Ocfs2-devel] [PATCH 3/3] o2net: correct keepalive message
 protocol
In-Reply-To: <1264740671-908-4-git-send-email-srinivas.eeda@oracle.com>
References: <1264740671-908-1-git-send-email-srinivas.eeda@oracle.com>
	<1264740671-908-4-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20100217055641.GI13798@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jan 28, 2010 at 08:51:11PM -0800, Srinivas Eeda wrote:
>  		case O2NET_MSG_KEEP_REQ_MAGIC:
> -			o2net_sendpage(sc, o2net_keep_resp,
> -				       sizeof(*o2net_keep_resp));
> +			/* Each node now sends keepalive message every
> +			 * keepalive time interval. Hence no need for response
> +			 */
>  			goto out;

	You still have to send the response.  Think about a mixed
environment where some nodes have this fix and some do not.  The older
software is still waiting on the response.
	The newer version can just ignore any responses it gets from
other nodes.  But it has to send responses out just in case the other
node is older.
	The only other alternative is to bump the o2net protocol
version, and that means the cluster has to be shut down to upgrade.  Not
a good choice.

Joel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
