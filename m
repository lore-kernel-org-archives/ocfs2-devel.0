From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 18 Oct 2010 13:19:31 -0700
Subject: [Ocfs2-devel] [PATCH 13/22] ocfs2: use little endian bitops
In-Reply-To: <1287135981-17604-14-git-send-email-akinobu.mita@gmail.com>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-14-git-send-email-akinobu.mita@gmail.com>
Message-ID: <20101018201931.GB31479@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Mark Fasheh <mfasheh@suse.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, ocfs2-devel@oss.oracle.com

On Fri, Oct 15, 2010 at 06:46:12PM +0900, Akinobu Mita wrote:
> As a preparation for removing ext2 non-atomic bit operations from
> asm/bitops.h. This converts ext2 non-atomic bit operations to
> little endian bit operations.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <joel.becker@oracle.com>
> Cc: ocfs2-devel at oss.oracle.com

Acked-by: Joel Becker <joel.becker@oracle.com>


-- 

 There are morethings in heaven and earth, Horatio,
 Than are dreamt of in your philosophy.

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
