From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 14 Jul 2008 13:25:49 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2: Fix race between mount
	and	recovery
In-Reply-To: <1216066358-12090-3-git-send-email-sunil.mushran@oracle.com>
References: <1216066358-12090-1-git-send-email-sunil.mushran@oracle.com>
	<1216066358-12090-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080714202549.GB11110@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 14, 2008 at 01:12:38PM -0700, Sunil Mushran wrote:
> +	u32 *slot_recovery_generation;
> +

	It's a tiny thing, but maybe call it slot_recovery_generations,
because it refers to more than one (it's not "our slot's recover
generation" it's "recovery generations for all slots").
	Otherwise, lookin good.

Joel

-- 

"In the arms of the angel, fly away from here,
 From this dark, cold hotel room and the endlessness that you fear.
 You are pulled from the wreckage of your silent reverie.
 In the arms of the angel, may you find some comfort here."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
