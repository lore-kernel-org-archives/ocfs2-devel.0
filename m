From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Fri, 8 Oct 2010 14:03:15 -0500
Subject: [Ocfs2-devel] Question: recovery map vs replay map
Message-ID: <AANLkTik2S+-guvnhvUGXOBOD74Ph0gf68NgN9uMG5LyD@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I was reading through the recovery code and got confused with recovery
and replay maps.

What is the function of recovery maps and replay maps? Is a replay map
generated for each entry in the recovery map? Is there a situation
where a replay map is created without a recovery map entry?

Thanks,

-- 
Goldwyn
