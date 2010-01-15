From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 15 Jan 2010 13:36:33 -0800
Subject: [Ocfs2-devel] [PATCH 2/3] ocfs2:freeze-thaw: initialization and
 cleanup
In-Reply-To: <20100115024129.GD3760@laptop.oracle.com>
References: <201001091802.o09I2ZlW017091@acsinet15.oracle.com>
	<4B4FCA90.1090601@oracle.com>
	<20100115022628.GB3760@laptop.oracle.com>
	<4B4FD49B.6040809@oracle.com>
	<20100115024129.GD3760@laptop.oracle.com>
Message-ID: <4B50DFE1.7020800@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Wengang Wang wrote:
> we don't need to free it when we umount since we don't have that lock taken.
> we lock/unlock it in mount, and in the downconvert action.

We do have to free the lock. And you are doing it in 
ocfs2_dlm_shutdown(). ;)
I was looking at the wrong place. Sorry for the confusion.
