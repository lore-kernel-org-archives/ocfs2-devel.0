From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon Aug  9 14:05:18 2004
Subject: [Ocfs2-devel] Cluster sizes allowed?
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B0194AA20@orsmsx410>
References: <60C14C611F1DDD4198D53F2F43D8CA3B0194AA20@orsmsx410>
Message-ID: <20040809190512.GN2595@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Aug 09, 2004 at 10:13:11AM -0700, Villalovos, John L wrote:
> What are the cluster sizes allowed?

	The formula is 2^x where 12 <= x <= 20.  If you need a formula.
The acutal on-disk format stores the clustersize as the exponent
(OCFS_RAW_SB(sb_dinode)->s_clustersize_bits).  So
12 <= s_clustersize_bits <= 20, and clustersize == 1 <<
s_clustersize_bits.

Joel

-- 

Life's Little Instruction Book #356

	"Be there when people need you."

Joel Becker
Senior Member of Technical Staff
Oracle Corporation
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
