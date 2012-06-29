From: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 29 Jun 2012 03:29:00 -0700
Subject: [Ocfs2-devel] [PATCH v4 1/2] aio: make kiocb->private NUll in
 init_sync_kiocb()
In-Reply-To: <4FED80A7.7040507@oracle.com>
References: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com>
	<1340788195-20623-2-git-send-email-junxiao.bi@oracle.com>
	<20120628153956.9b7405d9.akpm@linux-foundation.org>
	<20120629092255.GB12521@dhcp-172-17-9-228.mtv.corp.google.com>
	<4FED80A7.7040507@oracle.com>
Message-ID: <20120629032900.15e36adf.akpm@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com, linux-kernel@vger.kernel.org, joe.jin@oracle.com, stable@vger.kernel.org

On Fri, 29 Jun 2012 18:17:11 +0800 Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Andrew had merged this patch to his tree. Do you like the second patch "
> ocfs2: clear unaligned io flag when dio fails"?

Please go ahead with your patchset for now.  I'll feed the cleanup in
later on.
