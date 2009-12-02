From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 01 Dec 2009 16:16:15 -0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Implement new OCFS2_IOC_INFO
 ioctl for ocfs2.
In-Reply-To: <4B14707A.3030302@oracle.com>
References: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>
	<1259310276-7782-2-git-send-email-tristan.ye@oracle.com>
	<4B145A07.3070107@oracle.com> <4B14707A.3030302@oracle.com>
Message-ID: <4B15B1CF.8000802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Tristan wrote:
> I always have a thought that memmove handled thing more gracefully 
> than memcpy when overlap happens.

Yes and hence we should to use it when there is even a small chance
of buffer overlap. But that is not the case here.
