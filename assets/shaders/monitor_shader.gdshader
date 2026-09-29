shader_type canvas_item;

// Добавляем uniform для screen texture
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float line_density : hint_range(50.0, 800.0) = 800.0;   // Кол-во горизонтальных линий
uniform float line_intensity : hint_range(0.0, 1.0) = 0.15;     // Тёмность полос
uniform float line_speed : hint_range(0.0, 10.0) = 0.0;         // Скорость дрейфа

uniform float vignette_strength : hint_range(0.0, 1.0) = 0.9;  // Насколько затемняются края
uniform float vignette_softness : hint_range(0.001, 1.0) = 0.6;// Плавность перехода
uniform vec2 vignette_center = vec2(0.5, 0.5);                  // Центр виньетки
uniform float vignette_aspect = 1.0;                            // Соотношение сторон экрана

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 col = texture(SCREEN_TEXTURE, uv);

    // VHS горизонтальные полосы
    float phase = uv.y * line_density + TIME * line_speed;
    float stripes = 0.5 + 0.5 * sin(phase);
    float stripe_mask = 1.0 - line_intensity * smoothstep(0.3, 0.7, stripes);
    col.rgb *= stripe_mask;

    // Виньетка
    vec2 p = uv - vignette_center;
    p.x *= vignette_aspect;
    float dist = length(p);
    float inner = max(0.0, 1.0 - vignette_strength);
    float outer = inner + vignette_softness;
    float vig = smoothstep(inner, outer, dist);
    col.rgb = mix(col.rgb, vec3(0.0), vig * vignette_strength);

    COLOR = col;
}