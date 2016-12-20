From: Fengguang Wu <lkp@intel.com>
Date: Tue, 20 Dec 2016 09:47:13 +0800
Subject: [Ocfs2-devel]
 =?utf-8?b?W2tidWlsZC1hbGxdIOetlOWkje+8miBSZTogW1BB?=
 =?utf-8?q?TCH_1/2=5D_ocfs2=3A_add_kobject_for_online_file_check?=
In-Reply-To: <58592784020000F9001B856C@prv-mh.provo.novell.com>
References: <1482139287-19040-2-git-send-email-ghe@suse.com>
	<201612191811.4gtVVyNv%fengguang.wu@intel.com>
	<58592784020000F9001B856C@prv-mh.provo.novell.com>
Message-ID: <20161220014713.zf2ksqzeb7tz75gw@wfg-t540p.sh.intel.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang He <ghe@suse.com>
Cc: mfasheh@versity.com, linux-kernel@vger.kernel.org, kbuild-all@01.org, akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com, jlbec@evilplan.org

Hi Gang,

On Mon, Dec 19, 2016 at 06:43:48PM -0700, Gang He wrote:
>Hello Kbuild,
>Could you build my whole patch set (2 patch)? I think that the code is OK.

We test your whole patch as well as first-N patches, and noticed that
the first-1 patch breaks bisectibility:

>Note: the linux-review/Gang-He/ocfs2-add-kobject-for-online-file-check/20161219-181858 HEAD 6ef9256cd25ef72a5e69490cc3dacde95b8e2ac4 builds fine.
>      It only hurts bisectibility.

Thanks,
Fengguang
