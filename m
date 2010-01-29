From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 28 Jan 2010 16:21:27 -0800
Subject: [Ocfs2-devel] dlmglue fixes
In-Reply-To: <20100126195305.GB17656@redhat.com>
References: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
	<20100126123325.GB3845@mail.oracle.com>
	<20100126163749.GA17656@redhat.com> <4B5F400A.9080909@oracle.com>
	<20100126195305.GB17656@redhat.com>
Message-ID: <4B622A07.8090806@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

David Teigland wrote:
> Oops, yeah, I missed copying that:
>
> Jan 26 10:08:31 bull-02 kernel: (1995,1):ocfs2_prepare_downconvert:3280 ERROR: lockres->l_level (0) <= new_level (0)
> Jan 26 10:08:31 bull-02 kernel: ------------[ cut here ]------------
> Jan 26 10:08:31 bull-02 kernel: kernel BUG at fs/ocfs2/dlmglue.c:3281!

Coly ran into the same sometime ago.
http://oss.oracle.com/bugzilla/show_bug.cgi?id=1178

I am going thru the traces.
