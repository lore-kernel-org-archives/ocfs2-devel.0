From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Nov 2009 15:03:12 -0800
Subject: [Ocfs2-devel] [PATCH 02/11] ocfs2: Handle workqueue changes
In-Reply-To: <1257972298-15590-3-git-send-email-sunil.mushran@oracle.com>
References: <1257972298-15590-1-git-send-email-sunil.mushran@oracle.com>
	<1257972298-15590-3-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091111230311.GH17774@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 11, 2009 at 12:44:55PM -0800, Sunil Mushran wrote:
> Mainline commit 52bad64d95bd89e08c49ec5a071fa6dcbe5a1a9c introduced
> struct delayed_work to separate delayable and non-delayable work.

	In patches like this, the commit message should describe how we
handled it.  Here, we'd say: "we create initialization and access
wrappers to handle the different APIs," or somethign like that.

Joel

-- 

Life's Little Instruction Book #24

	"Drink champagne for no reason at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
