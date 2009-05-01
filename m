From: Christoph Hellwig <hch@lst.de>
Date: Fri, 1 May 2009 09:34:56 +0200
Subject: [Ocfs2-devel] [PATCH 17/39] ocfs2: Add ioctl for reflink.
In-Reply-To: <1241045931-24607-17-git-send-email-tao.ma@oracle.com>
References: <49F95A79.6040806@oracle.com>
	<1241045931-24607-17-git-send-email-tao.ma@oracle.com>
Message-ID: <20090501073456.GA22000@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 30, 2009 at 06:58:29AM +0800, Tao Ma wrote:
> The ioctl will take 2 parameters: old_path and new_path and
> works like link.

As discussed during the FS/Storage summit please make this a proper
sys_reflink system call and don't add a stupid ioctl.
