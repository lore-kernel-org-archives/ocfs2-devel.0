From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 17 Dec 2009 21:10:40 -0800
Subject: [Ocfs2-devel] Add FIEMAP_EXTENT_SHARED flag
In-Reply-To: <1259873212-20107-1-git-send-email-sunil.mushran@oracle.com>
References: <1259873212-20107-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091218051040.GB20149@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Thu, Dec 03, 2009 at 12:46:50PM -0800, Sunil Mushran wrote:
> Please could you Ack this patch. This adds a new FIEMAP flag to denote
> shared extents which we are using to identify such exents in reflinked
> files.

	These patches are now in ocfs2.git.  If anyone has any concerns,
let me know.

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
