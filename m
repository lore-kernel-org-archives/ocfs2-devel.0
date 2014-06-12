From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 12 Jun 2014 16:32:53 -0700
Subject: [Ocfs2-devel] [patch 6/8] ocfs2: fix a tiny race when
	running	dirop_fileop_racer
In-Reply-To: <20140609200405.C8C6A5A4A39@corp2gmr1-2.hot.corp.google.com>
References: <20140609200405.C8C6A5A4A39@corp2gmr1-2.hot.corp.google.com>
Message-ID: <20140612233253.GF5484@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

My memory of this one is fuzzy. It looked good to me but I asked that some
of the extraneous logging be removed if it was something a user could
trigger. That obviuosly never happened.

If you want to just change ML_NOTICE and ML_ERROR in the patch to '0'
(marks thems as debug) then I would happily ack it.

Thanks,
	--Mark

--
Mark Fasheh
