From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 20 Jul 2009 17:27:48 -0700
Subject: [Ocfs2-devel] Initialize count in aio_write before
 generic_write_checks
In-Reply-To: <20090711155727.GA11989@baloo.cartoons>
References: <20090711155727.GA11989@baloo.cartoons>
Message-ID: <20090721002748.GA9183@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jul 11, 2009 at 10:57:27AM -0500, Goldwyn Rodrigues wrote:
> generic_write_checks() expects count to be initialized to the size of
> the write.
> Writes to files open with O_DIRECT|O_LARGEFILE write 0 bytes because
> count in uninitialized.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.de>

This is now in the fixes branch of ocfs2.git

Joel

-- 

Life's Little Instruction Book #237

	"Seek out the good in people."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
