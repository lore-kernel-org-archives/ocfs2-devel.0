From: Gang He <ghe@suse.com>
Date: Mon, 19 Dec 2016 20:00:55 -0700
Subject: [Ocfs2-devel] =?utf-8?b?562U5aSN77yaIFJlOiBba2J1aWxkLWFsbF0g562U?=
 =?utf-8?b?5aSN77yaIFJlOiBbUEFUQ0ggMS8yXSBvY2ZzMjogYWRkIGtvYmplY3QgZm9y?=
 =?utf-8?q?_online_file_check?=
In-Reply-To: <20161220014713.zf2ksqzeb7tz75gw@wfg-t540p.sh.intel.com>
References: <1482139287-19040-2-git-send-email-ghe@suse.com>
	<201612191811.4gtVVyNv%fengguang.wu@intel.com>
	<58592784020000F9001B856C@prv-mh.provo.novell.com>
	<20161220014713.zf2ksqzeb7tz75gw@wfg-t540p.sh.intel.com>
Message-ID: <58593997020000F9001B859F@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lkp@intel.com
Cc: kbuild-all@01.org, jlbec@evilplan.org, akpm@linux-foundation.org, ocfs2-devel@oss.oracle.com, mfasheh@versity.com, linux-kernel@vger.kernel.org

Hi Fengguang and all,
I will reconstruct my patch set, to make sure each patch can follow this rule.

Thanks
Gang 

>>> Fengguang Wu <lkp@intel.com> 2016-12-20 ?? 9:47 >>>
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
