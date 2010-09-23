From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 15:34:35 -0700
Subject: [Ocfs2-devel] [PATCH 15/20] ocfs2/cluster: Maintain bitmap of
 quorum regions
In-Reply-To: <1284504656-2434-16-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
	<1284504656-2434-16-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100923223435.GE803@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 14, 2010 at 03:50:51PM -0700, Sunil Mushran wrote:
> +	printk(KERN_NOTICE "o2hb: Region %s is now a quorum device\n",
> +	       config_item_name(&reg->hr_item));

	I'm thinking that this is a valid message.

Joel
-- 

Life's Little Instruction Book #510

	"Count your blessings."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
