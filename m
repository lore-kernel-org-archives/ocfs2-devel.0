From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 11 Nov 2009 15:06:12 -0800
Subject: [Ocfs2-devel] [PATCH 11/11] ocfs2: Handle different f_version
 types
In-Reply-To: <1257972298-15590-6-git-send-email-sunil.mushran@oracle.com>
References: <1257972298-15590-1-git-send-email-sunil.mushran@oracle.com>
	<1257972298-15590-6-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20091111230612.GJ17774@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 11, 2009 at 12:44:58PM -0800, Sunil Mushran wrote:
> Mainline commit 2b47c3611de05c585e2d81204f6c7e3e255a3461 changed type of
> file->f_version from unsigned long to u64. 

... We wrap f_version in a type called f_version_t so that functions
don't have to care about the width of the type ...

> This patch allows building with
> kernels having either definition. Build fails if the type is something else.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

-- 

Bram's Law:
	The easier a piece of software is to write, the worse it's
	implemented in practice.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
