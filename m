From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 15 Aug 2012 02:04:57 -0700
Subject: [Ocfs2-devel] OCFS + QUOTA - Many errors in dmesg - Mayby fix
 that?
In-Reply-To: <AF11BCE64D6647C0B14576AA905DF52A@SERWER>
References: <AF11BCE64D6647C0B14576AA905DF52A@SERWER>
Message-ID: <20120815090456.GN31083@dhcp-172-17-9-228.mtv.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Aug 15, 2012 at 10:29:18AM +0200, Marek Kr?likowski wrote:
> Hey
> I see You remove ocfs2_global_read_info errors from dmesg can You remove other stupid errors too?
> I got kernel 3.2.27 with enable quota on OCFS2 and i got many many errors likes:
> 
> (local,19395,1):ocfs2_write_begin:1953 ERROR: status = ?122

<snip>

You shouldn't see any of these.  Patch coming.

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

			http://www.jlbec.org/
			jlbec at evilplan.org
