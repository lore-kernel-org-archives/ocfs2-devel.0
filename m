From: Fabian Frederick <fabf@skynet.be>
Date: Wed, 9 Apr 2014 06:22:45 +0200
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: Remove NULL assignments on
 static
In-Reply-To: <534499FA.8010107@oracle.com>
References: <20140408221342.9759bea1dd852f2787f82586@skynet.be>
	<534499FA.8010107@oracle.com>
Message-ID: <20140409062245.3aafb6e5f5039380f8e4c757@skynet.be>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wengang <wen.gang.wang@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com

On Wed, 09 Apr 2014 08:53:14 +0800
Wengang <wen.gang.wang@oracle.com> wrote:

> Hi Fabian,
> 
> What's the badness if we do the assignments?
> 
> thanks,
> wengang

Hi Wengang,

	Nothing wrong but AFAICS redundant.

Regards,
Fabian
