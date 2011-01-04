From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 04 Jan 2011 10:43:20 -0800
Subject: [Ocfs2-devel] [PATCH 00/34] OCFS2: Add trace event and replace
 mlog(0).
In-Reply-To: <4D22E32D.40406@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
	<20101231125217.GC21179@mail.oracle.com>	<4D1DF2A3.9090106@tao.ma>
	<20101231223951.GC20521@mail.oracle.com> <4D22E32D.40406@tao.ma>
Message-ID: <4D236A48.1070703@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 01/04/2011 01:06 AM, Tao Ma wrote:
> #find /sys/kernel/debug/tracing/events/ocfs2 -type d|wc -l
> give me 319. Every trace event dir has 4 members(enable,filter,format
> and id). So it contains about 1600(dir+files).
>

That's a lot. ext4 currently has < 40.

I am wondering whether it is wise to treat this as a mlog replacement.

One suggestion would be to not remove all mlogs (other than remove _enter
and _exit as they are completely useless). Add trace events one by one. Coarse
tracing like ext4 has. Remove only those mlogs.
