From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 3 Dec 2009 18:55:30 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Incorrect address of pos
 passed to __generic_file_aio_read()
In-Reply-To: <1259867892-1635-1-git-send-email-sunil.mushran@oracle.com>
References: <1259867892-1635-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091204025530.GC4861@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 03, 2009 at 11:18:12AM -0800, Sunil Mushran wrote:
> __generic_file_aio_read() was being passed as incorrect address for pos
> leading to a run-away read.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

ack


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
