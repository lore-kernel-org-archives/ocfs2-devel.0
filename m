From: rae l <crquan@gmail.com>
Date: Wed Dec 12 20:19:48 2007
Subject: [Ocfs2-devel] BTW: could some oracle people make the
	oss.oracle.com website more faster?
In-Reply-To: <476022DD.10303@oracle.com>
References: <91b13c310712120920k5898a260h6c859c1db4061940@mail.gmail.com>
	<47601E9C.2050008@suse.de> <476022DD.10303@oracle.com>
Message-ID: <91b13c310712122019lefd94d6vd5948b73215fc78d@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Dec 13, 2007 2:05 AM, Sunil Mushran <Sunil.Mushran@oracle.com> wrote:
> It's almost all text. One small image.
>
> See if wget can help you pinpoint the problem.
>
> $ wget -r -l1 http://oss.oracle.com/projects/ocfs2/
> Run it in a temp dir.
and the download spped of files under oss.oracle.com/projects/ are
always below 3KB/s:

--12:15:11--  http://oss.oracle.com/projects/ocfs2-tools/dist/files/source/v1.3/ocfs2-tools-1.3.9.tar.gz
  (try: 2) => `/usr/portage/distfiles/ocfs2-tools-1.3.9.tar.gz'
Connecting to oss.oracle.com|141.146.12.120|:80... connected.
HTTP request sent, awaiting response... 206 Partial Content
Length: 517,192 (505K), 515,804 (504K) remaining [application/x-gzip]

 8% [=>                                 ] 43,028         2.48K/s    ETA 09:02

-- 
Denis Cheng
