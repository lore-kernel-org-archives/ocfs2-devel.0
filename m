From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 2 Dec 2009 14:56:37 -0800
Subject: [Ocfs2-devel] [PATCH] o2net: delay ENOTCONN for sends receives
 till quorum decision
In-Reply-To: <1258703846-23212-2-git-send-email-srinivas.eeda@oracle.com>
References: <1258703846-23212-1-git-send-email-srinivas.eeda@oracle.com>
	<1258703846-23212-2-git-send-email-srinivas.eeda@oracle.com>
Message-ID: <20091202225637.GB31647@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Nov 19, 2009 at 11:57:26PM -0800, Srinivas Eeda wrote:
> -	o2net_hand->o2net_reconnect_delay_ms = cpu_to_be32(
> -		o2net_reconnect_delay());

	You take out the reconnect delay here, but you don't remove the
configfs attribute.  What are we still using the delay for?

Joel

-- 

Life's Little Instruction Book #197

	"Don't forget, a person's greatest emotional need is to 
	 feel appreciated."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
