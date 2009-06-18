From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 18 Jun 2009 09:06:02 -0700
Subject: [Ocfs2-devel] [PATCH 0/2] orphan lock fixes for local mode.
In-Reply-To: <20090618150645.GA7725@mail.oracle.com>
References: <4A39F138.9050503@oracle.com>
	<20090618150645.GA7725@mail.oracle.com>
Message-ID: <4A3A65EA.1060804@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Jun 18, 2009 at 03:48:08PM +0800, Tao Ma wrote:
>   
>> Hi Joel/Srini,
>> 	Here are 2 patches for orphan lock in local mode.
>> patch 1:
>> 	In local mode, we don't need lvb, so don't init it.
>> patch 2:
>> 	In local mode, orphan lock and unlock don't need to go to dlm part.
>>     
> 	I would think we don't even need the orphan scan in local mode.
>
> Joel

Tao, Good catch.

Yes, we don't need the orphan scan in local mount. The earlier patch
that scans all the orphans slots mount should be sufficient.

Not calling ocfs2_orphan_scan_init() in ocfs2_initialize_super() should
be sufficient. But we should add Tao's patch 2 too for completeness.

Sunil
