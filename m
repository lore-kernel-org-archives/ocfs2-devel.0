From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 7 Jul 2008 13:51:20 -0700
Subject: [Ocfs2-devel] [PATCH 3/4] ocfs2: Fixes tiny race between
	mount	and recovery
In-Reply-To: <1215462380-12975-4-git-send-email-sunil.mushran@oracle.com>
References: <1215462380-12975-1-git-send-email-sunil.mushran@oracle.com>
	<1215462380-12975-4-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080707205120.GC8651@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 07, 2008 at 01:26:19PM -0700, Sunil Mushran wrote:
> +struct ocfs2_recovery_item {
> +	unsigned int ri_node_num;
> +	unsigned int ri_count;
> +};

	Also, what's the point of the count here?  To try and recover
more than once?

Joel

-- 

 Brain: I shall pollute the water supply with this DNAdefibuliser,
        turning everyone into mindless slaves.
 Pinky: What about the people who drink bottled water?
 Brain: Pinky, people who pay 5 dollars for a bottle of water are
        already mindless slaves.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
