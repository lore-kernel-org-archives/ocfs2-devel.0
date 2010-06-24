From: Jeff Moyer <jmoyer@redhat.com>
Date: Thu, 24 Jun 2010 10:56:28 -0400
Subject: [Ocfs2-devel] [PATCH 0/3 v5][RFC] ext3/4: enhance fsync
	performance when using CFQ
In-Reply-To: <4C22F316.3080009@oracle.com> (Tao Ma's message of "Thu, 24 Jun
	2010 13:54:30 +0800")
References: <1277242502-9047-1-git-send-email-jmoyer@redhat.com>
	<4C21D442.8080703@oracle.com> <4C22F316.3080009@oracle.com>
Message-ID: <x49r5jwh42r.fsf@segfault.boston.devel.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tao Ma <tao.ma@oracle.com>
Cc: axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, Joel Becker <joel.becker@oracle.com>, Sunil Mushran <sunil.mushran@oracle.com>, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

Tao Ma <tao.ma@oracle.com> writes:

> Hi Jeff,
>
[...]
> I am sorry to say that the patch make jbd2 locked up when I tested
> fs_mark using ocfs2.
> I have attached the log from my netconsole server. After I reverted
> the patch [3/3], the box works again.

Thanks for the report, Tao, I'll try to reproduce it here and get back
to you.

Cheers,
Jeff
