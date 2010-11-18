From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 18 Nov 2010 15:43:43 -0800
Subject: [Ocfs2-devel] ocfs2: char is not always signed
In-Reply-To: <1290054011_17741@mail4.comsite.net>
References: <1290054011_17741@mail4.comsite.net>
Message-ID: <20101118234343.GK19821@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Milton Miller <miltonm@bga.com>
Cc: Tao Ma <tao.ma@oracle.com>, ocfs2-devel@oss.oracle.com, Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.de>

On Wed, Nov 17, 2010 at 10:20:11PM -0600, Milton Miller wrote:
> Commit 1c66b360fe262 (Change some lock status member in ocfs2_lock_res
> to char.)  states that these fields need to be signed due to comparision
> to -1, but only changed the type from unsigned char to char.   However, it
> is a compiler option if char is a signed or unsigned type.  Change these
> fields to signed char so the code will work with all compilers.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"This is the end, beautiful friend.
 This is the end, my only friend the end
 Of our elaborate plans, the end
 Of everything that stands, the end
 No safety or surprise, the end
 I'll never look into your eyes again."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
