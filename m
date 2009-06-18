From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 18 Jun 2009 08:06:46 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] orphan lock fixes for local mode.
In-Reply-To: <4A39F138.9050503@oracle.com>
References: <4A39F138.9050503@oracle.com>
Message-ID: <20090618150645.GA7725@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Jun 18, 2009 at 03:48:08PM +0800, Tao Ma wrote:
> Hi Joel/Srini,
> 	Here are 2 patches for orphan lock in local mode.
> patch 1:
> 	In local mode, we don't need lvb, so don't init it.
> patch 2:
> 	In local mode, orphan lock and unlock don't need to go to dlm part.

	I would think we don't even need the orphan scan in local mode.

Joel

-- 

"Every day I get up and look through the Forbes list of the richest
 people in America. If I'm not there, I go to work."
        - Robert Orben

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
