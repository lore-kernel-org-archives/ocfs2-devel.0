From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 18 13:03:41 2008
Subject: [Ocfs2-devel] Re: [PATCH] ocfs2: le*_add_cpu conversion
In-Reply-To: <1202857582-15450-14-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
	<1202857582-15450-14-git-send-email-marcin.slusarz@gmail.com>
Message-ID: <20080218210313.GB22671@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, Kurt Hackel <kurt.hackel@oracle.com>, ocfs2-devel@oss.oracle.com

On Wed, Feb 13, 2008 at 12:06:18AM +0100, marcin.slusarz@gmail.com wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> replace all:
> little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
> generated with semantic patch


Thanks, this is in ocfs2.git now.
	--Mark
--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
