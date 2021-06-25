import random
from pyecharts import options as opts
from pyecharts.charts import Scatter3D
#from pyecharts.constants import DEFAULT_HOST
REMOTE_HOST = ""
from flask import Flask, render_template


app = Flask(__name__)


@app.route("/")
def hello():
    s3d = scatter3d()
    return render_template('pyecharts.html',
                           myechart=s3d.render_embed(),
                           #host=DEFAULT_HOST,
                           host=REMOTE_HOST)
                           #script_list=s3d.get_js_dependencies())


def scatter3d():
    data = [generate_3d_random_point() for _ in range(80)]
    range_color = [
        '#313695', '#4575b4', '#74add1', '#abd9e9', '#e0f3f8', '#ffffbf',
        '#fee090', '#fdae61', '#f46d43', '#d73027', '#a50026']
    scatter3D = Scatter3D(init_opts = opts.InitOpts(width='1200px', height='600px'))
    #scatter3D.add("", data, is_visualmap=True, visual_range_color=range_color)
    scatter3D.add("", data)
    scatter3D.set_global_opts(
        title_opts = opts.TitleOpts(title = "3D Demo"),
        visualmap_opts = opts.VisualMapOpts(
            max_ = 50,
            pos_top = 50,
            range_color= 0x444444,
        )
    )
    return scatter3D


def generate_3d_random_point():
    return [random.randint(0, 100),
            random.randint(0, 100),
            random.randint(0, 100)]


if __name__ == "__main__":
    #运行项目
    app.run(debug = True)

